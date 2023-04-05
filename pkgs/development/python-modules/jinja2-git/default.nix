{ lib
, buildPythonPackage
, fetchFromGitHub
, jinja2
, poetry-core
}:

buildPythonPackage rec {
  pname = "jinja2-git";
  version = "unstable-2021-07-20";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "jinja2-git";
    # this is master, we can't patch because of poetry.lock :(
    # luckily, there appear to have been zero API changes since then, only
    # dependency upgrades
    rev = "c6d19b207eb6ac07182dc8fea35251d286c82512";
    sha256 = "0yw0318w57ksn8azmdyk3zmyzfhw0k281fddnxyf4115bx3aph0g";
  };

  nativeBuildInputs = [ poetry-core ];
  propagatedBuildInputs = [ jinja2 ];
  pythonImportsCheck = [ "jinja2_git" ];

  meta = with lib; {
    homepage = "https://github.com/wemake-services/jinja2-git";
    description = "Jinja2 extension to handle git-specific things";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
