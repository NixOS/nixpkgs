{ lib
, buildPythonPackage
, fetchFromGitHub
, bluepy
}:

buildPythonPackage rec {
  pname = "avea";
  version = "1.5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "k0rventen";
    repo = pname;
    rev = "v${version}";
    sha256 = "1dirf0zdf4hb941w1dvh97vsvcy4h3w9r8jwdgr1ggmhdf9kfx4v";
  };

  propagatedBuildInputs = [
    bluepy
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "avea" ];

  meta = with lib; {
    description = "Python module for interacting with Elgato's Avea bulb";
    homepage = "https://github.com/k0rventen/avea";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
