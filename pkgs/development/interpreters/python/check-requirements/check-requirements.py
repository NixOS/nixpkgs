# Check whether dependencies listed in a requiremens.txt are found
# in the current environment.
#
# Based on https://github.com/pypa/pip/issues/2733#issuecomment-257340871
import argparse
import pip
from pip.req import parse_requirements
import pkg_resources
from pkg_resources import DistributionNotFound, VersionConflict


def get_dependencies(requirement_file_name):
    dependencies = []
    session = pip.download.PipSession()
    for req in parse_requirements(requirement_file_name, session=session):
        if req.req is not None:
            dependencies.append(str(req.req))
        else:
            # The req probably refers to a url. Depending on the
            # format req.link.url may be able to be parsed to find the
            # required package.
            pass
    return dependencies


def check_dependencies(dependencies):
    """Checks to see if the python dependencies are fullfilled.
    If check passes return 0. Otherwise print error and return 1
    """
    try:
        pkg_resources.working_set.require(dependencies)
    except VersionConflict as exc:
        try:
            print("{} was found on your system, "
                  "but {} is required.\n".format(e.dist, e.req))
            return(0)
        except AttributeError:
            print(e)
            return 1
    except DistributionNotFound as e:
        print(e)
        return 1
    return 0


def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument("file")
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_arguments()
    dependencies = get_dependencies(args.file)
    exit(check_dependencies(dependencies))
