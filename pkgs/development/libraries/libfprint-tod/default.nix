{ lib
, libfprint
, fetchFromGitLab
}:

# for the curious, "tod" means "Touch OEM Drivers" meaning it can load
# external .so's.
libfprint.overrideAttrs ({ postPatch ? "", mesonFlags ? [], ... }: let
  version = "1.94.1+tod1";
in  {
  pname = "libfprint-tod";
  inherit version;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "3v1n0";
    repo = "libfprint";
    rev = "v${version}";
    sha256 = "sha256-IVeTQlZjea4xgbG/N7OTHAj6RT4WutfvQhV8qFEvkKo=";
  };

  mesonFlags = mesonFlags ++ [
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
})
