{
  lib,
  arrow,
  buildPythonPackage,
  fetchFromGitHub,
  freetype,
  glibcLocales,
  libjpeg,
  pillow,
  pocket,
  pyfiglet,
  pysocks,
  python,
  python-dateutil,
  requests,
  twitter,
  zlib,
}:

buildPythonPackage rec {
  pname = "rainbowstream";
  version = "1.5.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "orakaro";
    repo = pname;
    # Request for tagging, https://github.com/orakaro/rainbowstream/issues/314
    rev = "96141fac10675e0775d703f65a59c4477a48c57e";
    sha256 = "0j0qcc428lk9b3l0cr2j418gd6wd5k4160ham2zn2mmdmxn5bldg";
  };

  buildInputs = [
    freetype
    glibcLocales
    libjpeg
    zlib
  ];

  propagatedBuildInputs = [
    arrow
    pillow
    pocket
    pyfiglet
    pysocks
    python-dateutil
    requests
    twitter
  ];

  patches = [ ./image.patch ];

  postPatch = ''
    clib=$out/${python.sitePackages}/rainbowstream/image.so
    substituteInPlace rainbowstream/c_image.py \
      --replace @CLIB@ $clib
    sed -i 's/requests.*"/requests"/' setup.py
  '';

  LC_ALL = "en_US.UTF-8";

  postInstall = ''
    mkdir -p $out/lib
    cc -fPIC -shared -o $clib rainbowstream/image.c
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" \
        --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "rainbowstream" ];

  meta = with lib; {
    description = "Streaming command-line twitter client";
    mainProgram = "rainbowstream";
    homepage = "https://github.com/orakaro/rainbowstream";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
