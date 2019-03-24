DOCSTRING_DELIM = '"""'

def split_module_docstring(lines):
    module_docstring = []
    rest = []
    if not lines[0].startswith(DOCSTRING_DELIM):
        return ([], lines)

    if '"""' in lines[0][3:]:
        return ([lines[0]], lines[1:])

    end_index = 1
    for line in lines[1:]:
        end_index += 1
        if '"""' in line:
            break

    return (lines[:end_index], lines[end_index:])

def inject_lines(filename, addition):
    with open(filename, "r+") as f:
        old = f.readlines()
        (docstring, rest) = split_module_docstring(old)
        f.seek(0)
        f.write("".join(docstring + addition + rest))

def main():
    import argparse
    parser = argparse.ArgumentParser(description='Wrap python libraries')
    parser.add_argument('file', type=str, help='File to wrap')
    parser.add_argument('-p', '--prefix', type=str, action='append', dest='prefixes', nargs=3, default=[])

    args = parser.parse_args()
    lines_to_add = [
        'import os\n'
    ]
    for prefix in args.prefixes:
        var_to_prefix = prefix[0]
        sep = prefix[1]
        value = prefix[2]
        lines_to_add += [
            # TODO add escaping
            f'os.environ["{var_to_prefix}"] = "{value}{sep}" + os.environ.get("{var_to_prefix}", "")\n'
        ]
    inject_lines(args.file, lines_to_add)

if __name__ == "__main__":
    main()
