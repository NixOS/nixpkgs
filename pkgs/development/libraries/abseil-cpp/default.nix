{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "abseil-cpp-${version}";
  date = "20190322";
  rev = "eab2078b53c9e3d9d240135c09d27e3393acb50a";
  version = "${date}-${rev}";

  src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "${rev}";
    sha256 = "1bpz44hxq5fpkv6jlgphzk7mxjiiah526jgb63ih5pd1hd2cfw1r";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "An open-source collection of C++ code designed to augment the C++ standard library";
    homepage = https://abseil.io/;
    license = licenses.asl20;
    maintainers = [ maintainers.andersk ];
  };
}
