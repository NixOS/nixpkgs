{ stdenv, buildPythonPackage, fetchPypi, isPy3k, boto, crcmod, psutil }:

buildPythonPackage rec {
  pname = "buttersink";
  version = "0.6.9";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c9c05982c44fbb85f17b7ef0e8bee11f375c03d89bcba50cbc2520013512107a";
  };

  propagatedBuildInputs = [ boto crcmod psutil ];

  meta = with stdenv.lib; {
    description = "Synchronise btrfs snapshots";
    longDescription = ''
      ButterSink is like rsync, but for btrfs subvolumes instead of files,
      which makes it much more efficient for things like archiving backup
      snapshots. It is built on top of btrfs send and receive capabilities.
      Sources and destinations can be local btrfs file systems, remote btrfs
      file systems over SSH, or S3 buckets.
    '';
    homepage = https://github.com/AmesCornish/buttersink/wiki;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
