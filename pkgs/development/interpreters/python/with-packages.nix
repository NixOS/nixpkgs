{ buildEnv, pythonPackages }:

f: let packages = f pythonPackages; in buildEnv.override { extraLibs = packages; }
