{ stdenv, fetchurl, buildPythonPackage, sphinx, rpmextract, nss, requests,
  six }:

buildPythonPackage rec {
  name = "pki-core-${version}";
  version = "10.3.5";

  rpmFile = "${name}-7.fc25.src.rpm";

  src = fetchurl {
    url = "mirror://fedora/linux/releases/25/Everything/source/tree/Packages/p/${rpmFile}";
    sha256 = "18kva88qqjfbkccaw1j889jfm95zk8a63xhy05ldj07yfqz38vsz";
  };

  patches = [
    "pki-core-snapshot-1.patch"
    "pki-core-snapshot-2.patch"
    "pki-core-snapshot-3.patch"
    "pki-core-snapshot-4.patch"
    "pki-core-fedora-post-snapshot-1.patch"
  ];

  patchFlags = "-p1 -F 3";

  nativeBuildInputs = [ rpmextract ];
  buildInputs = [ sphinx ];
  propagatedBuildInputs = [ nss requests six ];

  unpackPhase = ''
    rpmextract $src
    tar -xf ${name}.tar.gz
    mv *.patch ${name}/
    mkdir ${name}/specs
    mv pki-core.spec ${name}/specs/
  '';

  sourceRoot = name;

  preBuild = ''
    cd base/common/python
    unset SOURCE_DATE_EPOCH
  '';

  meta = with stdenv.lib; {
    description = "Client library for Dogtag Certificate System";
    homepage    = http://pki.fedoraproject.org/;
    license     = licenses.lgpl3Plus;
    maintainers = [ maintainers.e-user ];
  };
}
