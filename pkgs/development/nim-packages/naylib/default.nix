{ lib
  , nimPackages
  , fetchFromGitHub
  , raylib
  , libX11
  , libXi
  , libXxf86vm
  , libxkbcommon
  , libXcursor
  , libXrandr 
  , libXinerama 
}:

nimPackages.buildNimPackage rec {
  pname = "naylib";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "planetis-m";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-18YiAzJ46dpD5JN+gH0MWKchZ5YLPBNcm9eVFnyy2Sw=";
  };

  propagatedBuildInputs = [ 
    raylib 
    libX11 
    libXi 
    libXxf86vm 
    libxkbcommon 
    libXcursor 
    libXrandr 
    libXinerama 
  ];

  doCheck = false; # no $DISPLAY available

  meta = with lib; {
    homepage = "https://github.com/planetis-m/naylib";
    description = "Yet another raylib Nim wrapper";
    license = licenses.mit;
    maintainers = with maintainers; [ miragearhitect ];
  };
}
