{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "precis-i18n";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "byllyfish";
    repo = "precis_i18n";
    rev = "refs/tags/v${version}";
    hash = "sha256-rtg3u8lnnmQFPsNC52LNVoEVu6CeHzAWvOjWBlzLKC4=";
  };

  pythonImportsCheck = [ "precis_i18n" ];

  meta = with lib; {
    description = "Internationalized usernames and passwords";
    homepage = "https://github.com/byllyfish/precis_i18n";
    changelog = "https://github.com/byllyfish/precis_i18n/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
