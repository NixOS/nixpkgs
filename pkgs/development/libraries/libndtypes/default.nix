{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  name = "libndtypes-${version}";
  version = "unstable-2018-11-27";

  src = fetchFromGitHub {
    owner = "plures";
    repo = "ndtypes";
    rev = "4d810d0c4d54c81a7136f313f0ae6623853d574a";
    sha256 = "1kk1sa7f17ffh49jc1qlizlsj536fr3s4flb6x4rjyi81rp7psb9";
  };

  # Override linker with cc (symlink to either gcc or clang)
  # Library expects to use cc for linking
  configureFlags = [ "LD=${stdenv.cc.targetPrefix}cc" ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Dynamic types for data description and in-memory computations";
    homepage = https://xnd.io/;
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
