import os
import sys
from glob import iglob
from shutil import copyfile
from tempfile import NamedTemporaryFile

import requirements


try:
    NIX_DEBUG = int(os.environ.get("NIX_DEBUG", "0")) >= 7
except ValueError:
    NIX_DEBUG = False


def debug_msg(*args):
    if NIX_DEBUG:
        print(f"setuptoolsDepsVersionsHook:", *args, file=sys.stderr)


def fix_deps(requirements_txt, relax_python_deps, remove_python_deps):
    with NamedTemporaryFile(mode="w") as tmp:
        with open(requirements_txt, mode="r") as f:
            for req in requirements.parse(f):
                if remove_python_deps == True or req.name in remove_python_deps:
                    if isinstance(remove_python_deps, list):
                        remove_python_deps.remove(req.name)
                    debug_msg(f"Removing '{req.name}' dependency")
                    continue
                elif relax_python_deps == True or req.name in relax_python_deps:
                    if isinstance(relax_python_deps, list):
                        relax_python_deps.remove(req.name)
                    debug_msg(f"Relaxing '{req.name}' dependency")
                    print(req.name, file=tmp)
                else:
                    print(req.line, file=tmp)

        # Should have replaced all declared removePythonDeps/relaxPythonDeps
        assert (
            remove_python_deps == True or remove_python_deps == []
        ), f"These declared deps in removePythonDeps were not found in '{requirements_txt}' file: {remove_python_deps}"
        assert (
            relax_python_deps == True or relax_python_deps == []
        ), f"These declared deps in relaxPythonDeps were not found in '{requirements_txt}' file: {relax_python_deps}"

        tmp.flush()
        copyfile(tmp.name, requirements_txt)


def get_and_parse_nix_env_var(env_var, default_value=""):
    # nix converts true to 1, false to 0 and arrays to space-separated string
    env = os.environ.get(env_var, default_value)
    if env == "0":
        return False
    elif env == "1":
        return True
    else:
        return env.split()


def main():
    # From glob documentation: https://docs.python.org/3/library/glob.html
    # > Using the “**” pattern in large directory trees may consume an inordinate amount of time.
    # Shouldn't be an issue for most Python projects, but if it is best is to set
    # `requirementsTxt` to something specific for your project
    requirements_txts = iglob(
        os.environ.get("requirementsTxt", "**/requirements*.txt"), recursive=True
    )
    relax_python_deps = get_and_parse_nix_env_var("relaxPythonDeps")
    remove_python_deps = get_and_parse_nix_env_var("removePythonDeps")

    for requirements_txt in requirements_txts:
        debug_msg(f"Fixing {requirements_txt} file")

        fix_deps(requirements_txt, relax_python_deps, remove_python_deps)

        debug_msg(f"Resulting {requirements_txt} file:")
        if NIX_DEBUG:
            with open(requirements_txt, mode="r") as f:
                print(f.read(), file=sys.stderr)


if __name__ == "__main__":
    main()
