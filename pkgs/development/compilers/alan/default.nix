{ stdenv, lib, fetchFromGitHub
, cgreen, openjdk, pkg-config, which
}:

stdenv.mkDerivation rec {
  pname = "alan";
  version = "3.0beta8";

  src = fetchFromGitHub {
    owner = "alan-if";
    repo = "alan";
    rev = "v${version}";
    sha256 = "0zfg1frmb4yl39hk8h733bmlwk4rkikzfhvv7j34cxpdpsp7spzl";
  };

  postPatch = ''
    patchShebangs --build bin
    # The Makefiles have complex CFLAGS that don't allow separate control of optimization
    sed -i 's/-O0/-O2/g' compiler/Makefile.common
    sed -i 's/-Og/-O2/g' interpreter/Makefile.common
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/alan/examples
    # Build the release tarball
    make package
    # The release tarball isn't split up into subdirectories
    tar -xf alan*.tgz --strip-components=1 -C $out/share/alan
    mv $out/share/alan/*.alan $out/share/alan/examples
    chmod a-x $out/share/alan/examples/*.alan
    mv $out/share/alan/{alan,arun} $out/bin
    # a2a3 isn't included in the release tarball
    cp bin/a2a3 $out/bin
  '';

  nativeBuildInputs = [
    cgreen
    openjdk pkg-config which
  ];

  meta = with lib; {
    homepage = "https://www.alanif.se/";
    description = "The Alan interactive fiction language";
    license = licenses.artistic2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ neilmayhew ];
  };
}
