{ stdenv, lib, fetchFromGitHub, gnome3, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-material-shell";
  version = "7";

  src = fetchFromGitHub {
    owner = "material-shell";
    repo = "material-shell";
    rev = version;
    sha256 = "076cv1l5qr5x71przjwvbzx0m91n4z0byc2gc3r48l8vsr2d0hwf";
  };

  patches = [
    # Fix for https://github.com/material-shell/material-shell/issues/284
    # (Remove this patch when updating to version >= 8)
    (fetchpatch {
      url = "https://github.com/material-shell/material-shell/commit/fc27489a1ec503a4a5c7cb2f4e1eefa84a7ea2f1.patch";
      sha256 = "0x2skg955c4jqgwbkfhk7plm8bh1qnk66cdds796bzkp3hb5syw8";
    })
  ];

  # This package has a Makefile, but it's used for building a zip for
  # publication to extensions.gnome.org. Disable the build phase so
  # installing doesn't build an unnecessary release.
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r * $out/share/gnome-shell/extensions/${uuid}/
    runHook postInstall
  '';

  uuid = "material-shell@papyelgringo";

  meta = with stdenv.lib; {
    description = "A modern desktop interface for Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ benley ];
    homepage = "https://github.com/material-shell/material-shell";
    platforms = gnome3.gnome-shell.meta.platforms;
  };
}
