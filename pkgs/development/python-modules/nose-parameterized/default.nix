{ fetchPypi, parameterized }:

parameterized.overrideAttrs (o: rec {
  pname = "nose-parameterized";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1khlabgib4161vn6alxsjaa8javriywgx9vydddi659gp9x6fpnk";
  };
})
