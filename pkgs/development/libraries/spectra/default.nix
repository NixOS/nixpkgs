{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  eigen,
}:

stdenv.mkDerivation rec {
  pname = "spectra";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "yixuan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HaJmMo4jYmO/j53/nHrL3bvdQMAvp4Nuhhe8Yc7pL88=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ eigen ];

  meta = with lib; {
    homepage = "https://spectralib.org/";
    description = "A C++ library for large scale eigenvalue problems, built on top of Eigen";
    license = licenses.mpl20;
    maintainers = with maintainers; [ vonfry ];
    platforms = platforms.unix;
  };
}
