{ cage
, fetchFromGitLab
, gnome
, lib
, meson
, ninja
, python3
, weston
, xorg
, xwayland
, withMutter ? false
, withCage ? false
}:
let
  compositors = [ weston ]
    ++ lib.optional withMutter gnome.mutter
    ++ lib.optional withCage cage
  ;
in
python3.pkgs.buildPythonApplication rec {
  pname = "xwayland-run";
  version = "0.0.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "ofourdan";
    repo = "xwayland-run";
    rev = version;
    hash = "sha256-+HdRLIizEdtKWD8HadQQf750e2t1AWa14U/Xwu3xPK4=";
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
    description = "A set of small utilities revolving around running Xwayland and various Wayland compositor headless";
    homepage = "https://gitlab.freedesktop.org/ofourdan/xwayland-run";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ arthsmn ];
    platforms = platforms.linux;
  };
}
