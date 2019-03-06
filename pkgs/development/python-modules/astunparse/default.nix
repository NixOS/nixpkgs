{ stdenv
, fetchPypi
, buildPythonPackage
, six
, wheel
 }:

buildPythonPackage rec {
  pname = "astunparse";
  version =  "1.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dab3e426715373fd76cd08bb1abe64b550f5aa494cf1e32384f26fd60961eb67";
  };

  propagatedBuildInputs = [ six wheel ];

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "This is a factored out version of unparse found in the Python source distribution";
    homepage = https://github.com/simonpercivall/astunparse;
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
