{ stdenv, fetchurl, buildPythonPackage, nss, nspr, six }:

let
  inherit (stdenv.lib) concatStringsSep replaceStrings;
in
buildPythonPackage rec {
  name = "nss-${version}";
  version = "1.0.0";
  src = fetchurl {
    url = "https://ftp.mozilla.org/pub/security/python-nss/releases/PYNSS_RELEASE_${replaceStrings ["."] ["_"] version}/src/python-${name}.tar.bz2";
    sha1 = "8403f759a514726b9360b68f4d5e4f50bc422197";
  };

  buildInputs = [ nss nspr six nss ];
  patchPhase = ''
    sed -i -e "s/find_include_dir(\['nspr4', 'nspr'\]/find_include_dir(['.']/" setup.py
    sed -i -e "s#include_roots = \[\]#include_roots = [${concatStringsSep ", " (map (pkg: "'" + pkg.dev + "/include'") [ nss nspr ])}]#" setup.py
    for file in test/{setup_certs,test_pkcs12}.py; do
      substituteInPlace $file \
        --replace /usr/bin/certutil ${nss.tools}/bin/certutil \
        --replace /usr/bin/modutil ${nss.tools}/bin/modutil \
        --replace /usr/bin/pk12util ${nss.tools}/bin/pk12util
    done
  '';

  checkPhase = ''
    export PYTHONPATH=$(echo $(pwd)/build/lib.*):$PYTHONPATH
    $PYTHON test/run_tests
  '';

  meta = with stdenv.lib; {
    description = "Python binding for NSS";
    homepage    = https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS/Python_binding_for_NSS;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ e-user ];
  };
}
