{ lib, buildPythonPackage, fetchdarcs, zope_interface, isPy3k }:

buildPythonPackage rec {
  pname = "python-application";
  version = "2.0.2";
  disabled = isPy3k;

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/${pname}";
    rev = "release-${version}";
    sha256 = "19dszv44py8qrq0jcjdycxpa7z2p8hi3ijq9gnqdsazbbjzf9svn";
  };

  buildInputs = [ zope_interface ];

  meta = with lib; {
    description = "Basic building blocks for python applications";
    homepage = https://github.com/AGProjects/python-application;
    license = licenses.lgpl2Plus;
  };
}
