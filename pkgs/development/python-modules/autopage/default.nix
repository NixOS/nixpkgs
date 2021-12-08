{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "autopage";
  version = "0.4.0";

  format = "pyproject";

  src = fetchFromGitHub {
     owner = "zaneb";
     repo = "autopage";
     rev = "v0.4.0";
     sha256 = "14a1r6c1ll22687mbx6mckh1c542i2rwvnvd8as66m87v2v6wzfy";
  };

  pythonImportsCheck = [ "autopage" ];

  meta = with lib; {
    description = "A library to provide automatic paging for console output";
    homepage = "https://github.com/zaneb/autopage";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
