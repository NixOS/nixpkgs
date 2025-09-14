{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openmp,
}:

stdenv.mkDerivation rec {
  pname = "vid.stab";
  version = "unstable-2022-05-30";

  src = fetchFromGitHub {
    owner = "georgmartius";
    repo = pname;
    rev = "90c76aca2cb06c3ff6f7476a7cd6851b39436656";
    sha256 = "sha256-p1VRnkBeUpET3O2FmaJMyN5/EoSOQLdmRIVbzZcQaKY=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = lib.optionals stdenv.cc.isClang [ openmp ];

  meta = {
    description = "Video stabilization library";
    homepage = "http://public.hronopik.de/vid.stab/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ codyopel ];
    platforms = lib.platforms.all;
  };
}
