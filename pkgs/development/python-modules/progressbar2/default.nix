{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, python-utils
}:

buildPythonPackage (rec {
  name = "${pname}-${version}";
  pname = "progressbar2";
  version = "3.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16r21cpjvv0spf4mymgpy7hx6977iy11k44n2w9kipwg4lhwh02k";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ python-utils ];
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://progressbar-2.readthedocs.io/en/latest/;
    description = "Text progressbar library for python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ashgillman ];
  };
})
