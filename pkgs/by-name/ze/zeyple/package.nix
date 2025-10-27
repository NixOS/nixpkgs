{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "zeyple";
  version = "unstable-2021-04-10";

  format = "other";

  src = fetchFromGitHub {
    owner = "infertux";
    repo = "zeyple";
    rev = "cc125b7b44432542b227887fd7e2701f77fd8ca2";
    sha256 = "0r2d1drg2zvwmn3zg0qb32i9mh03r5di9q1yszx23r32rsax9mxh";
  };

  # SafeConfigParser was deprecated in Python 3.12: https://github.com/infertux/zeyple/issues/76
  postPatch = ''
    substituteInPlace zeyple/zeyple.py \
      --replace-fail 'from configparser import SafeConfigParser' 'from configparser import ConfigParser as SafeConfigParser'
  '';

  propagatedBuildInputs = [ python3Packages.gpgme ];
  installPhase = ''
    runHook preInstall

    install -Dm755 zeyple/zeyple.py $out/bin/zeyple

    runHook postInstall
  '';

  meta = with lib; {
    description = "Utility program to automatically encrypt outgoing emails with GPG";
    homepage = "https://infertux.com/labs/zeyple/";
    maintainers = with maintainers; [ ettom ];
    license = licenses.agpl3Plus;
    mainProgram = "zeyple";
  };
}
