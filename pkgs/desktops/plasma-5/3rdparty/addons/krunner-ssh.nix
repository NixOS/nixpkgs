{
  lib,
  stdenv,
  fetchFromGitLab,
  python3,
}:
let
  pythonEnv = python3.withPackages (
    p: with p; [
      dbus-python
      pygobject3
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "krunner-ssh";
  version = "1.0";

  src = fetchFromGitLab {
    owner = "Programie";
    repo = "krunner-ssh";
    rev = version;
    sha256 = "sha256-rFTTvmetDeN6t0axVc+8t1TRiuyPBpwqhvsq2IFxa/A=";
  };

  postPatch = ''
    sed -e "s|Exec=.*|Exec=$out/libexec/runner.py|" -i ssh-runner.service
  '';

  nativeBuildInputs = [
    pythonEnv
  ];

  installPhase = ''
    runHook preInstall

    patchShebangs runner.py

    install -m 0755 -D runner.py $out/libexec/runner.py
    install -m 0755 -D ssh-runner.desktop $out/share/kservices5/ssh-runner.desktop
    install -m 0755 -D ssh-runner.service $out/share/dbus-1/services/com.selfcoders.ssh-runner.service

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple backend for KRunner providing SSH hosts from your .ssh/known_hosts file as search results";
    homepage = "https://selfcoders.com/projects/krunner-ssh";
    license = licenses.mit;
    maintainers = with maintainers; [ aanderse ];
    platforms = platforms.linux;
  };
}
