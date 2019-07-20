{ lib, buildPythonPackage, fetchPypi, zope_interface, isPy3k }:

buildPythonPackage rec {
  pname = "python-application";
  version = "2.7.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sf9415QDwbBE5dexSEJmPgraCys1dZV94gf7MG+TbdM=";
  };

  patchPhase = ''
    sed \
      -e 's/    import twisted/    #import twisted/g' \
      -i application/log/extensions/twisted/twisted.py
  '';

  buildInputs = [ zope_interface ];

  meta = with lib; {
    description = "Basic building blocks for python applications";
    homepage = https://github.com/AGProjects/python-application;
    license = licenses.lgpl2Plus;
  };
}
