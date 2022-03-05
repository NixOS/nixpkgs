{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "nsync";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = version;
    sha256 = "sha256-jQJtlBDR6efBe1tFOUOZ6awaMTT33qM/GbvbwiWTZxw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/google/nsync";
    description = "C library that exports various synchronization primitives";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ puffnfresh ];
    # On macOS we get an error for some reason:
    # > mkdir: cannot create directory 'build': File exists
    platforms = lib.platforms.linux;
  };
}
