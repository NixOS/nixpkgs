#!/usr/bin/env bash

cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

TYPES="html pdf-a4 pdf-letter text texinfo"
URL=http://www.python.org/ftp/python/doc/VERSION/python-VERSION-docs-TYPE.tar.bz2
VERSIONS=$(for major in 2 3; do curl https://docs.python.org/$major/archives/ 2>/dev/null | perl -l -n -e'/<a href="python-([23].[0-9]+.[0-9]+)-docs-html.tar.bz2/ && print $1' | tail -n 1; done)
echo "Generating expressions for:
${VERSIONS}
"


cat >default.nix <<EOF
{ stdenv, fetchurl, lib }:

let
pythonDocs = {
EOF

for type in $TYPES; do
    cat >>default.nix <<EOF
  ${type/-/_} = {
    recurseForDerivations = true;
EOF

    for version in $VERSIONS; do
        major=$(echo -n ${version}| cut -d. -f1)
        minor=$(echo -n ${version}| cut -d. -f2)
        if [ "${type}" = "texinfo" ]; then
            if [ "${major}" = "2" ]; then
                # Python 2 doesn't have pregenerated texinfos available
                continue
            fi
            template=template-info.nix
        else
            template=template.nix
        fi
        outfile=${major}.${minor}-${type}.nix
        hash=
        if [ -e ${outfile} ]; then
            currentversion=$(grep "url =" ${outfile} |cut -d/ -f7)
            if [ ${version} = ${currentversion} ]; then
                hash=$(grep sha256 ${outfile} | cut -d'"' -f2)
            fi
        fi
        echo "Generating ${outfile}"
        url=$(echo -n $URL |sed -e "s,VERSION,${version},g" -e "s,TYPE,${type},")
        sha=$(nix-prefetch-url ${url} ${hash})


        sed -e "s,VERSION,${version}," \
            -e "s,MAJOR,${major}," \
            -e "s,MINOR,${minor}," \
            -e "s,TYPE,${type}," \
            -e "s,URL,${url}," \
            -e "s,SHA,${sha}," < ${template} > ${outfile}

        attrname=python${major}${minor}
        cat >>default.nix <<EOF
    ${attrname} = import ./${major}.${minor}-${type}.nix {
      inherit stdenv fetchurl lib;
    };
EOF

        echo "done."
        echo
    done
    echo "  };" >> default.nix
done

echo "}; in pythonDocs" >> default.nix
