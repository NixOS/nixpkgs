{ lib, buildPythonPackage, fetchdarcs, zope_interface, isPy3k }:

buildPythonPackage rec {
  pname = "python-application";
  version = "2.7.0";
  disabled = isPy3k;

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/${pname}";
    rev = "release-${version}";
    sha256 = "1xpyk2v3naxkjhpyris58dxg1lxbraxgjd6f7w1sah5j0sk7psla";
  };

  buildInputs = [ zope_interface ];

  meta = with lib; {
    description = "Basic building blocks for python applications";
    homepage = https://github.com/AGProjects/python-application;
    license = licenses.lgpl2Plus;
  };
}
