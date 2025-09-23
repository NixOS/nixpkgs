{
  buildRedist,
  lib,
  python3,
}:
buildRedist {
  redistName = "cuda";
  pname = "mft_autocomplete";

  # TODO: includes bin, etc, include, lib, and share directories.
  outputs = [ "out" ];

  postPatch = ''
    nixLog "patching python path in $PWD/etc/bash_completion.d/mft/mft_base_autocomplete"
    substituteInPlace "$PWD/etc/bash_completion.d/mft/mft_base_autocomplete" \
      --replace-fail \
        "PYTHON_EXEC='/usr/bin/env python3'" \
        "PYTHON_EXEC='${lib.getExe python3}'" \
      --replace-fail \
        "PYTHON_EXEC='/usr/bin/env python2'" \
        "PYTHON_EXEC='${lib.getExe python3}'"

    nixLog "patching python shebang path in $PWD/etc/bash_completion.d/mft/mft_help_to_completion.py"
    substituteInPlace "$PWD/etc/bash_completion.d/mft/mft_help_to_completion.py" \
      --replace-fail \
        '#!/usr/bin/python' \
        '#!${lib.getExe python3}'
  '';

  brokenAssertions = [
    {
      # The mft_base_autocomplete file needs heavier patching to remove FHS references and ensure it uses Nixpkgs' python.
      # In particular, it does something like
      # PYTHON_EXEC=`find /usr/bin /bin/ /usr/local/bin -iname 'python*' 2>&1 | grep -e='*python[0-9,.]*' | sort -d | head -n 1`
      message = "contains no references to FHS paths";
      assertion = false;
    }
  ];
}
