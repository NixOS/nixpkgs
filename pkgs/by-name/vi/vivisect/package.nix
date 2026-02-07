{ python3Packages }:
python3Packages.toPythonApplication python3Packages.(vivisect.override { withGui = true; })
