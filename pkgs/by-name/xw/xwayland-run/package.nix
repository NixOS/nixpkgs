{ fetchFromGitLab
, lib
, meson
, ninja
, python3
, weston
, xorg
, xwayland
, withCage ? false , cage
, withKwin ? false , kdePackages
, withMutter ? false, gnome
, withDbus ? withMutter , dbus # Since 0.0.3, mutter compositors run with their own DBUS sessions
}:
let
  compositors = [ weston ]
    ++ lib.optional withCage cage
    ++ lib.optional withKwin kdePackages.kwin
    ++ lib.optional withMutter gnome.mutter ++ lib.optional withDbus dbus
  ;
in
python3.pkgs.buildPythonApplication rec {
  pname = "xwayland-run";
  version = "0.0.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "ofourdan";
    repo = "xwayland-run";
    rev = version;
    hash = "sha256-yYULbbcFDT1zRFn1UWS0dyuchGYnOZypDmxqc14RYF4=";
  };

  pyproject = false;

  outputs = [ "out" "man" ];

  nativeBuildInputs = [
    meson
    ninja
  ];

  postInstall = ''
    wrapProgram $out/bin/wlheadless-run \
      --prefix PATH : ${lib.makeBinPath compositors}
    wrapProgram $out/bin/xwayland-run \
      --prefix PATH : ${lib.makeBinPath [ xwayland xorg.xauth ]}
    wrapProgram $out/bin/xwfb-run \
      --prefix PATH : ${lib.makeBinPath (compositors ++ [ xwayland xorg.xauth ])}
  '';

  meta = with lib; {
    description = "Set of small utilities revolving around running Xwayland and various Wayland compositor headless";
    homepage = "https://gitlab.freedesktop.org/ofourdan/xwayland-run";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ arthsmn ];
    platforms = platforms.linux;
  };
}
