{ lib
, stdenv
, fetchFromGitHub
, formats
, systemd
}:

let
  ini = formats.ini { };

  unit = ini.generate "systembus-notify.service" {
    Unit = {
      Description = "system bus notification daemon";
    };

    Service = {
      Type = "exec";
      ExecStart = "@out@/bin/systembus-notify";
      PrivateTmp = true;
      # NB. We cannot `ProtectHome`, or it would block session dbus access.
      InaccessiblePaths = "/home";
      ReadOnlyPaths = "/run/user";
      ProtectSystem = "strict";
      Restart = "on-failure";
      Slice = "background.slice";
    };
  };

in
stdenv.mkDerivation rec {
  pname = "systembus-notify";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "systembus-notify";
    rev = "v${version}";
    sha256 = "sha256-WzuBw7LXW54CCMgFE9BSJ2skxaz4IA2BcBny63Ihtt0=";
  };

  buildInputs = [ systemd ];

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin systembus-notify
    install -Dm444 -t $out/share/systembus-notify systembus-notify.desktop

    install -d $out/lib/systemd/user
    substitute ${unit} $out/lib/systemd/user/${unit.name} \
      --subst-var out

    runHook postInstall
  '';

  # requires a running dbus instance
  doCheck = false;

  meta = with lib; {
    description = "System bus notification daemon";
    homepage = "https://github.com/rfjakob/systembus-notify";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    mainProgram = "systembus-notify";
  };
}
