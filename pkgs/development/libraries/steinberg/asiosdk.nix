{ requireFile, fetchzip }:

fetchzip {
  name = "asiosdk-2.3";
  url = "file://" + requireFile {
    url = http://www.steinberg.net/sdk_downloads/asiosdk2.3.zip;
    sha256 = "16qvyfc5hnsy9pgzq3xgxmlm799rb6spcq2cg1lgajhlx4h508k9";
  };
  sha256 = "1nn8qaym1nyhz8w4s3w7cfyg01c8900qn1z1ncqpbz182zmr5hci";
}
