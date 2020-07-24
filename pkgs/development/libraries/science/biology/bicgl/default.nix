{ stdenv, fetchFromGitHub, cmake, libminc, bicpl, freeglut, mesa_glu }:

stdenv.mkDerivation rec {
  pname = "bicgl";
  name  = "${pname}-2017-09-10";

  owner = "BIC-MNI";

  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = "b7f7e52d1039d6202a93d9055f516186033656cc";
    sha256 = "0lzirdi1mf4yl8srq7vjn746sbydz7h0wjh7wy8gycy6hq04qrg4";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libminc bicpl freeglut mesa_glu ];

  cmakeFlags = [ "-DLIBMINC_DIR=${libminc}/lib" "-DBICPL_DIR=${bicpl}/lib" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/${owner}/${pname}";
    description = "Brain Imaging Centre graphics library";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
