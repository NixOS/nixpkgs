{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pam,
  six,
  toml,
}:

buildPythonPackage rec {
  pname = "python-pam";
  version = "2.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "FirefighterBlu3";
    repo = "python-pam";
    tag = "v${version}";
    hash = "sha256-MR9LYXtkbltAmn7yoyyKZn4yMHyh3rj/i/pA8nJy2xU=";
  };

  postPatch = ''
    substituteInPlace src/pam/__internals.py \
      --replace 'find_library("pam")' '"${pam}/lib/libpam.so"' \
      --replace 'find_library("pam_misc")' '"${pam}/lib/libpam_misc.so"'
  '';

  nativeBuildInputs = [ setuptools ];

  buildInputs = [ pam ];

  propagatedBuildInputs = [
    six
    toml
  ];

  pythonImportsCheck = [ "pam" ];

  meta = with lib; {
    description = "Python pam module";
    homepage = "https://github.com/FirefighterBlu3/python-pam";
    license = licenses.mit;
    maintainers = with maintainers; [
      mkg20001
    ];
  };
}
