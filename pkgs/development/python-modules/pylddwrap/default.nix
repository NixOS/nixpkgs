{ lib
, buildPythonPackage
, coreutils
, fetchFromGitHub
, icontract
, pytestCheckHook
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pylddwrap";
  version = "1.2.2";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Parquery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Gm82VRu8GP52BohQzpMUJfh6q2tiUA2GJWOcG7ymGgg=";
  };

  postPatch = ''
    substituteInPlace lddwrap/__init__.py \
      --replace '/usr/bin/env' '${coreutils}/bin/env'
  '';

  # Upstream adds some plain text files direct to the package's root directory
  # https://github.com/Parquery/pylddwrap/blob/master/setup.py#L71
  postInstall = ''
    rm -f $out/{LICENSE,README.rst,requirements.txt}
  '';

  propagatedBuildInputs = [
    icontract
    typing-extensions
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lddwrap" ];

  meta = with lib; {
    description = "Python wrapper around ldd *nix utility to determine shared libraries of a program";
    homepage = "https://github.com/Parquery/pylddwrap";
    changelog = "https://github.com/Parquery/pylddwrap/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ thiagokokada ];
  };
}
