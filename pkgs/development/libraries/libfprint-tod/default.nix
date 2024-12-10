{
  lib,
  libfprint,
  fetchFromGitLab,
}:

# for the curious, "tod" means "Touch OEM Drivers" meaning it can load
# external .so's.
libfprint.overrideAttrs (
  {
    postPatch ? "",
    mesonFlags ? [ ],
    ...
  }:
  let
    version = "1.90.7+git20210222+tod1";
  in
  {
    pname = "libfprint-tod";
    inherit version;

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "3v1n0";
      repo = "libfprint";
      rev = "v${version}";
      sha256 = "0cj7iy5799pchyzqqncpkhibkq012g3bdpn18pfb19nm43svhn4j";
    };

    mesonFlags = [
      # Include virtual drivers for fprintd tests
      "-Ddrivers=all"
      "-Dudev_hwdb_dir=${placeholder "out"}/lib/udev/hwdb.d"
    ];

    postPatch = ''
      ${postPatch}
      patchShebangs ./tests/*.py ./tests/*.sh
    '';

    meta = with lib; {
      homepage = "https://gitlab.freedesktop.org/3v1n0/libfprint";
      description = "A library designed to make it easy to add support for consumer fingerprint readers, with support for loaded drivers";
      license = licenses.lgpl21;
      platforms = platforms.linux;
      maintainers = with maintainers; [ grahamc ];
    };
  }
)
