#include <GLFW/glfw3.h>
#include <cstdlib>
#include <iostream>

#include <imgui.h>
#include <imgui_impl_glfw.h>
#include <imgui_impl_opengl3.h>

template <typename T> class Finally {
private:
  T f;

public:
  Finally(T f) : f(std::move(f)) {}
  virtual ~Finally() { f(); }

  Finally(Finally &) = delete;
  Finally(Finally &&) = delete;
};

template <typename T> void abort(const T &msg) {
  std::cerr << msg << std::endl;
  std::abort();
}

void glfwPrintAbort(int error, const char *msg) { abort(msg); }

int main(int argc, char *argv[]) {
  glfwSetErrorCallback(glfwPrintAbort);
  if (!glfwInit()) {
    abort("glfwInit() failed");
  }
  Finally delGlfw([]() { glfwTerminate(); });

  glfwWindowHint(GLFW_RESIZABLE, GL_TRUE);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
  glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);

  const auto width = 768;
  const auto height = 512;
  const char title[] = "imgui demo";
  GLFWwindow *window = glfwCreateWindow(width, height, title, nullptr, nullptr);
  Finally delWindow([&]() { glfwDestroyWindow(window); });
  glfwMakeContextCurrent(window);

  IMGUI_CHECKVERSION();
  ImGui::CreateContext();
  ImGui_ImplGlfw_InitForOpenGL(window, true);
  ImGui_ImplOpenGL3_Init("#version 150");
  ImGui::StyleColorsDark();

  Finally delImgui([]() {
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplGlfw_Shutdown();
    ImGui::DestroyContext();
  });

  while (!glfwWindowShouldClose(window)) {

    glfwPollEvents();
    glClearColor(.45f, .55f, .6f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    Finally endGlfwFrame([&window]() {
      int dispWidth, dispHeight;
      glfwGetFramebufferSize(window, &dispWidth, &dispHeight);
      glViewport(0, 0, dispWidth, dispHeight);
      glfwSwapBuffers(window);
    });

    ImGui_ImplOpenGL3_NewFrame();
    ImGui_ImplGlfw_NewFrame();
    ImGui::NewFrame();
    Finally endFrame([]() {
      ImGui::Render();
      ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
    });

    if (ImGui::Begin("A window", nullptr)) {
    }
    ImGui::End();
  }
}
