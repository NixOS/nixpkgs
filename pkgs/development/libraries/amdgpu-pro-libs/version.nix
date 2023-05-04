{ pkgs }:
{
  suffix = if pkgs.stdenv.system == "x86_64-linux" then "64" else "32";
  amdbit = if pkgs.stdenv.system == "x86_64-linux" then "x86_64-linux-gnu" else "i386-linux-gnu";
  major = "22.40";
  major_short = "22.40";
  minor = "1577631";
  ubuntu_ver = "22.04";
  repo_folder_ver = "5.4.5";
  amf = "1.4.29";
}
