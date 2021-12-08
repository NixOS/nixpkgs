{ lib
, fetchFromGitHub
, buildPythonPackage
, six
, wheel
 }:

buildPythonPackage rec {
  pname = "astunparse";
  version =  "1.6.3";

  src = fetchFromGitHub {
     owner = "simonpercivall";
     repo = "astunparse";
     rev = "v1.6.3";
     sha256 = "10kqdhr2qn62ymsjv7wd853b29vc5386jvlahxq7rdmbazpgf8vw";
  };

  propagatedBuildInputs = [ six wheel ];

  # tests not included with pypi release
  doCheck = false;

  meta = with lib; {
    description = "This is a factored out version of unparse found in the Python source distribution";
    homepage = "https://github.com/simonpercivall/astunparse";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jyp ];
  };
}
