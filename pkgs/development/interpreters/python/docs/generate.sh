#!/usr/bin/env bash

TYPES="html pdf-a4 pdf-letter text"
URL=http://docs.python.org/ftp/python/doc/VERSION/python-VERSION-docs-TYPE.tar.bz2
VERSIONS=$(curl http://www.python.org/download/releases/ 2>/dev/null | grep "releases/[123456789]"| cut -d/ -f4 |grep -v "^[12].[012345]" |grep -v "^1.6.1")
echo "Generating expressions for:
${VERSIONS}
"


cat >default.nix <<EOF
{ stdenv, fetchurl }:

let
pythonDocs = {
EOF

for type in $TYPES; do
    echo "  ${type/-/_} = {" >> default.nix
    for version in $VERSIONS; do
        major=$(echo -n ${version}| cut -d. -f1)
        minor=$(echo -n ${version}| cut -d. -f2)
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
            -e "s,SHA,${sha}," < template.nix > ${outfile}

        attrname=python${major}${minor}
        cat >>default.nix <<EOF
    ${attrname} = import ./${major}.${minor}-${type}.nix {
      inherit stdenv fetchurl;
    };
EOF

        echo "done."
        echo
    done
    echo "  };" >> default.nix
done

echo "}; in pythonDocs" >> default.nix
