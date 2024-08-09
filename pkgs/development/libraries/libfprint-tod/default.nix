{ lib
, libfprint
, fetchFromGitLab
}:

# for the curious, "tod" means "Touch OEM Drivers" meaning it can load
# external .so's.
libfprint.overrideAttrs ({ postPatch ? "", mesonFlags ? [ ], ... }:
let
  version = "1.94.7+tod1";
in
{
  pname = "libfprint-tod";
  inherit version;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "3v1n0";
    repo = "libfprint";
    rev = "v${version}";
    sha256 = "sha256-q6m/J5GH86/z/mKnrYoanhKWR7+reKIRHqhDOUkknFA=";
  };

  patches = [
    # TODO: try fixing the check
    # https://gitlab.freedesktop.org/3v1n0/libfprint/-/commit/8e7e5bf7104df691217eda520b727470045cafcd
    ./revert-8e7e5bf7104df691217eda520b727470045cafcd.patch
  ];

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/3v1n0/libfprint";
    description = "Library designed to make it easy to add support for consumer fingerprint readers, with support for loaded drivers";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ grahamc ];
  };
})
