{ lib
, libfprint
, fetchFromGitLab
}:

# for the curious, "tod" means "Touch OEM Drivers" meaning it can load
# external .so's.
libfprint.overrideAttrs (old: rec {
  pname = "libfprint-tod";
  version = "1.94.7+tod1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "3v1n0";
    repo = "libfprint";
    rev = "v${version}";
    hash = "sha256-q6m/J5GH86/z/mKnrYoanhKWR7+reKIRHqhDOUkknFA=";
  };

  postPatch = old.postPatch + ''
    patchShebangs libfprint/tod/tests/check-library-symbols.sh
  '';

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/3v1n0/libfprint";
    description = "A library designed to make it easy to add support for consumer fingerprint readers, with support for loaded drivers";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ grahamc ];
  };
})
