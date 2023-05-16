{ lib
<<<<<<< HEAD
, stdenv
, buildPackages
, buildPythonPackage
, fetchFromGitHub
, installShellFiles
=======
, buildPythonPackage
, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, ruamel-yaml
, xmltodict
, pygments
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jc";
<<<<<<< HEAD
  version = "1.23.4";
=======
  version = "1.23.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kellyjonbrazil";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-d0KONiYS/5JXrl5izFSTYeABEhCW+W9cKpMgk9o9LB4=";
=======
    hash = "sha256-nj7HyYjo5jDnA+H5/er/GPgC/bUR0UYBqu5zOSDA4p0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [ ruamel-yaml xmltodict pygments ];

<<<<<<< HEAD
  nativeBuildInputs = [ installShellFiles ];

  postInstall = let emulator = stdenv.hostPlatform.emulator buildPackages; in ''
    installShellCompletion --cmd jc \
      --bash <(${emulator} $out/bin/jc --bash-comp) \
      --zsh  <(${emulator} $out/bin/jc --zsh-comp)
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jc" ];

  # tests require timezone to set America/Los_Angeles
  doCheck = false;

  meta = with lib; {
    description = "This tool serializes the output of popular command line tools and filetypes to structured JSON output";
    homepage = "https://github.com/kellyjonbrazil/jc";
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
    changelog = "https://github.com/kellyjonbrazil/jc/blob/v${version}/CHANGELOG";
<<<<<<< HEAD
    mainProgram = "jc";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
