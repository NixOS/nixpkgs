{ stdenv, fetchFromGitHub, cmake, pkg-config, gettext, libcsptr, dyncall
, nanomsg, python37Packages }:

stdenv.mkDerivation rec {
  version = "unstable-2019-09-19";
  pname = "boxfort";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = "BoxFort";
    rev = "926bd4ce968592dbbba97ec1bb9aeca3edf29b0d";
    sha256 = "0mzy4f8qij6ckn5578y3l4rni2470pdkjy5xww7ak99l1kh3p3v6";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    dyncall
    gettext
    libcsptr
    nanomsg
  ];

  checkInputs = with python37Packages; [ cram ];

  cmakeFlags = [ "-DBXF_FORK_RESILIENCE=OFF" ];

  doCheck = true;
  preCheck = ''
    export LD_LIBRARY_PATH=`pwd`''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
  '';

  outputs = [ "dev" "out" ];

  meta = with stdenv.lib; {
    description = "Convenient & cross-platform sandboxing C library";
    homepage = "https://github.com/Snaipe/BoxFort";
    license = licenses.mit;
    maintainers = with maintainers; [
      thesola10
      Yumasi
    ];
    platforms = platforms.unix;
  };
}
