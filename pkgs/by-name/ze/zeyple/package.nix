{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "zeyple";
  version = "unstable-2021-04-10";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "infertux";
    repo = "zeyple";
    rev = "cc125b7b44432542b227887fd7e2701f77fd8ca2";
    hash = "sha256-sNfUlc5i5CH61z7gFFvJA8CaohgLg/eHrXx/8XILTWQ=";
  };

  # SafeConfigParser was deprecated in Python 3.12: https://github.com/infertux/zeyple/issues/76
  postPatch = ''
    substituteInPlace zeyple/zeyple.py \
      --replace-fail 'from configparser import SafeConfigParser' 'from configparser import ConfigParser as SafeConfigParser'
  '';

  propagatedBuildInputs = [ python3Packages.gpg ];
  installPhase = ''
    runHook preInstall

    install -Dm755 zeyple/zeyple.py $out/bin/zeyple

    runHook postInstall
  '';

  meta = {
    description = "Utility program to automatically encrypt outgoing emails with GPG";
    homepage = "https://infertux.com/labs/zeyple/";
    maintainers = with lib.maintainers; [ ettom ];
    license = lib.licenses.agpl3Plus;
    mainProgram = "zeyple";
  };
}
