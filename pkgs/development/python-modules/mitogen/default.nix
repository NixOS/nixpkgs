{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "mitogen";
  version = "0.3.0rc1";

  src = fetchFromGitHub {
    owner = "mitogen-hq";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hxb41sshybxjyvyarl2axs0v6w53vqxafgfjrmpp5k20z5kapz4";
  };

  # Tests require network access and Docker support
  doCheck = false;

  pythonImportsCheck = [ "mitogen" ];

  meta = with lib; {
    description = "Python Library for writing distributed self-replicating programs";
    homepage = "https://github.com/mitogen-hq/mitogen";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
