{ fetchurl, lib, stdenv, pkg-config, gnome, glib, gtk3, clutter, dbus, python3, libxml2
, libxklavier, libXtst, gtk2, intltool, libxslt, at-spi2-core, autoreconfHook
, wrapGAppsHook3, libgee, vala }:

let
  pname = "caribou";
  version = "0.4.21";
  pythonEnv = python3.withPackages ( ps: with ps; [ pygobject3 ] );
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0mfychh1q3dx0b96pjz9a9y112bm9yqyim40yykzxx1hppsdjhww";
  };

  patches = [
    # Fix crash in GNOME Flashback
    # https://bugzilla.gnome.org/show_bug.cgi?id=791001
    (fetchurl {
      url = "https://bugzilla.gnome.org/attachment.cgi?id=364774";
      sha256 = "15k1455grf6knlrxqbjnk7sals1730b0whj30451scp46wyvykvd";
    })
    # Stop patching the generated GIR, fixes build with latest vala
    (fetchurl {
      url = "https://gitlab.gnome.org/GNOME/caribou/-/commit/c52ce71c49dc8d6109a58d16cc8d491d7bd1d781.patch";
      sha256 = "sha256-jbF1Ygp8Q0ENN/5aEpROuK5zkufIfn6cGW8dncl7ET4=";
    })
    (fetchurl {
      name = "fix-build-modern-vala.patch";
      url = "https://gitlab.gnome.org/GNOME/caribou/-/commit/76fbd11575f918fc898cb0f5defe07f67c11ec38.patch";
      sha256 = "0qy27zk7889hg51nx40afgppcx9iaihxbg3aqz9w35d6fmhr2k2y";
    })
    (fetchurl {
      name = "CVE-2021-3567.patch";
      url = "https://gitlab.gnome.org/GNOME/caribou/-/commit/d41c8e44b12222a290eaca16703406b113a630c6.patch";
      sha256 = "1vd2j3823k2p3msv7fq2437p3jvxzbd7hyh07i80g9754ylh92y8";
    })
  ];

  nativeBuildInputs = [ pkg-config intltool libxslt libxml2 autoreconfHook wrapGAppsHook3 vala ];

  buildInputs = [
    glib gtk3 clutter at-spi2-core dbus pythonEnv python3.pkgs.pygobject3
    libXtst gtk2
  ];

  propagatedBuildInputs = [ libgee libxklavier ];

  postPatch = ''
    patchShebangs .
    substituteInPlace libcaribou/Makefile.am --replace "--shared-library=libcaribou.so.0" "--shared-library=$out/lib/libcaribou.so.0"
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "An input assistive technology intended for switch and pointer users";
    mainProgram = "caribou-preferences";
    homepage = "https://gitlab.gnome.org/Archive/caribou";
    license = licenses.lgpl21;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
