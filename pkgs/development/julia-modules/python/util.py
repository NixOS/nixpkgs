
import os
import subprocess
import tempfile

def get_commit_info(repo):
  with tempfile.TemporaryDirectory() as home_dir:
    env_with_home = os.environ.copy()
    env_with_home["HOME"] = home_dir
    subprocess.check_output(["git", "config", "--global", "--add", "safe.directory", repo], env=env_with_home)
    lines = subprocess.check_output(["git", "log", "--pretty=raw"], cwd=repo, env=env_with_home).decode().split("\n")
    return dict([x.split() for x in lines if len(x.split()) == 2])
