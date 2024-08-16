{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "googletrans";
  version = "2.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ssut";
    repo = "py-googletrans";
    rev = "v${version}";
    sha256 = "0wzzinn0k9rfv9z1gmfk9l4kljyd4n6kizsjw4wjxv91kfhj92hz";
  };

  propagatedBuildInputs = [ requests ];

  # majority of tests just try to ping Google's Translate API endpoint
  doCheck = false;

  pythonImportsCheck = [ "googletrans" ];

  meta = with lib; {
    description = "Googletrans is python library to interact with Google Translate API";
    mainProgram = "translate";
    homepage = "https://py-googletrans.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ unode ];
  };
}
