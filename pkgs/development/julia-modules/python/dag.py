
# This file based on a ChatGPT reponse for the following prompt:
# "can you write code in python to build up a DAG representing
# a dependency tree, and then a function that can return all the
# dependencies of a given node?"

class Node:
    def __init__(self, name):
        self.name = name
        self.dependencies = set()


class DAG:
    def __init__(self):
        self.nodes = {}

    def add_node(self, node_name, dependencies=None):
        if node_name in self.nodes:
            raise ValueError(f"Node '{node_name}' already exists in the graph.")

        node = Node(node_name)
        if dependencies:
            node.dependencies.update(dependencies)

        self.nodes[node_name] = node

    def add_dependency(self, node_name, dependency_name):
        if node_name not in self.nodes:
            raise ValueError(f"Node '{node_name}' does not exist in the graph.")

        if dependency_name not in self.nodes:
            raise ValueError(f"Dependency '{dependency_name}' does not exist in the graph.")

        self.nodes[node_name].dependencies.add(dependency_name)

    def get_dependencies(self, node_name):
        if node_name not in self.nodes:
            raise ValueError(f"Node '{node_name}' does not exist in the graph.")

        node = self.nodes[node_name]
        dependencies = set()

        def traverse_dependencies(current_node):
            for dependency in current_node.dependencies:
                dependencies.add(dependency)
                if dependency in self.nodes:
                  traverse_dependencies(self.nodes[dependency])

        traverse_dependencies(node)
        return dependencies

    def has_node(self, node_name):
        return node_name in self.nodes

    def __str__(self):
        graph_str = ""
        for node_name, node in self.nodes.items():
            graph_str += f"{node_name} -> {', '.join(node.dependencies)}\n"
        return graph_str
