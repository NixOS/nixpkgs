{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, poetry-core
}:

buildPythonPackage rec {
  pname = "graphlib-backport";
  version = "1.1.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mariushelf";
    repo = "graphlib_backport";
    rev = version;
    hash = "sha256-ssJLtBQH8sSnccgcAKLKfYpPyw5U0RIm1F66/Er81lo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml        \
      --replace 'poetry>=1.0' 'poetry-core' \
      --replace 'poetry.masonry.api' 'poetry.core.masonry.api'
  '';

  propagatedBuildInputs = [
    setuptools
    poetry-core
  ];

  pythonImportsCheck = [ "graphlib" ];

  meta = with lib; {
    description = "Backport of the Python 3.9 graphlib module for Python 3.6+";
    homepage = "https://github.com/mariushelf/graphlib_backport";
    license = licenses.psfl;
    maintainers = with maintainers; [ t4ccer ];
  };
}
