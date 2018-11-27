{ stdenv, fetchFromGitHub, cmake, libminc }:

stdenv.mkDerivation {
  version = "unstable-2019-11-12";
  name    = "minc2-simple";

  src = fetchFromGitHub {
    owner  = "vfonov";
    repo   = "minc2-simple";
    rev    = "5cb5c0e8242885f6f6866cbfa9e1a16de5a9e6b6";
    sha256 = "sha256:1fmj237mq1vzbn8px4x9ddv9fspzff11na9ird9gaynhp0k9w9s5";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libminc ];

  cmakeFlags = [ "-DBUILD_TESTING=OFF" "-DLIBMINC_DIR=${libminc}/lib/" ];

  # tests don't actually run automatically, e.g., missing input files
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/vfonov/minc2-simple";
    description = "Simple interface to the libminc medical imaging library";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = [ "x86_64-linux" ];
    license   = licenses.free;
  };
}
