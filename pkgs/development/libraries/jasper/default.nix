{ stdenv, fetchFromGitHub, fetchpatch, libjpeg, cmake }:

stdenv.mkDerivation rec {
  pname = "jasper";
  version = "2.0.16";

  src = fetchFromGitHub {
    repo = "jasper";
    owner = "mdadams";
    rev = "version-${version}";
    sha256 = "05l75yd1zsxwv25ykwwwjs8961szv7iywf16nc6vc6qpby27ckv6";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-9055.patch";
      url = "http://paste.opensuse.org/view/raw/330751ce";
      sha256 = "0m798m6c4v9yyhql7x684j5kppcm6884n1rrb9ljz8p9aqq2jqnm";
    })
  ];


  # newer reconf to recognize a multiout flag
  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ libjpeg ];

  configureFlags = [ "--enable-shared" ];

  outputs = [ "bin" "dev" "out" "man" ];

  enableParallelBuilding = true;

  doCheck = false; # fails

  postInstall = ''
    moveToOutput bin "$bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://www.ece.uvic.ca/~frodo/jasper/;
    description = "JPEG2000 Library";
    platforms = platforms.unix;
    license = licenses.jasper;
    maintainers = with maintainers; [ pSub ];
    knownVulnerabilities = [
      "Numerous CVE unsolved upstream"
      "See: https://github.com/NixOS/nixpkgs/pull/57681#issuecomment-475857499"
      "See: https://github.com/mdadams/jasper/issues/208"
    ];
  };
}
