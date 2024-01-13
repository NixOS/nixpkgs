{ lib
, stdenv
, fetchFromGitHub
, uthash
, meson
, ninja
, pkg-config
, check
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdicom";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ImagingDataCommons";
    repo = "libdicom";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9n0Gp9+fmTM/shgWC8zpwt1pic9BrvDubOt7f+ZDMeE=";
  };

  buildInputs = [ uthash ];

  nativeBuildInputs = [ meson ninja pkg-config ]
    ++ lib.optionals (finalAttrs.finalPackage.doCheck) [ check ];

  mesonBuildType = "release";

  mesonFlags = lib.optionals (!finalAttrs.finalPackage.doCheck) [ "-Dtests=false" ];

  doCheck = true;

  meta = with lib; {
    description = "C library for reading DICOM files";
    homepage = "https://github.com/ImagingDataCommons/libdicom";
    license = licenses.mit;
    maintainers = with maintainers; [ lromor ];
    platforms = platforms.unix;
  };
})
