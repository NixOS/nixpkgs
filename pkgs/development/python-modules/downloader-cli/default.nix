{ lib, buildPythonPackage, fetchFromGitHub, urllib3, pytest }:

buildPythonPackage rec {
  pname = "downloader-cli";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "deepjyoti30";
    repo = pname;
    rev = version;
    sha256 = "0gbbjxb9vf5g890cls3mwzl8lmcn6jkpgm5cbrif740mn2b4q228";
  };

  propagatedBuildInputs = [ urllib3 ];

  # Disable checks due to networking (Errno 101)
  doCheck = false;

  pythonImportsCheck = [ "downloader_cli" ];

  meta = with lib; {
    description = "A simple downloader written in Python with an awesome customizable progressbar. ";
    homepage = "https://github.com/deepjyoti30/downloader-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ j0hax ];
  };
}
